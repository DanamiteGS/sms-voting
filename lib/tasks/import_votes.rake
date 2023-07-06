namespace :votes do
  desc "Import votes from log data"
  task import: :environment do
    VALID_LOG_FORMAT = ['Timestamp', 'Campaign', 'Validity', 'Choice', 'CONN', 'MSISDN', 'GUID', 'Shortcode'].freeze

    # https://www.seancdavis.com/posts/4-ways-to-pass-arguments-to-a-rake-task/
    # I opted for the third method described in the article since we only need to pass in one argument.
    file_path = ARGV[0]

    log_data = if file_path.nil?
      read_logs_from_prompt
    else
      read_logs_from_file(file_path)
    end

    if log_data.empty?
      puts "No votes log data provided. ¯\_(ツ)_/¯"
      exit
    end

    puts "\n\nImporting votes...\n\n"

    skipped_logs = []

    # https://necojackarc.hateblo.jp/entry/2015/11/04/034653
    # https://ruby-doc.org/core-2.2.3/Enumerable.html#method-i-each_slice
    log_data.each_slice(1000).with_index do |batch, index|
      puts "Processing batch #{index + 1} (-_-) zzz..."

      vote_data_batch, skipped = parse_logs(batch)
      skipped_logs << skipped

      valid_vote_data_batch = vote_data_batch.select { |vote_data| valid_vote?(vote_data) }

      ActiveRecord::Base.transaction do
        save_votes(valid_vote_data_batch)
      end
    end

    puts "\nDone!\n"

    display_skipped_logs(skipped_logs) unless skipped_logs.empty?
  end

  private

  def read_logs_from_prompt
    # https://zetcode.com/lang/rubytutorial/io/
    puts "Enter the log data below. Press Ctrl+D (or Ctrl+Z on Windows) to finish.\n"
    $stdin.read.split("\n").map(&:strip).reject(&:empty?)
  end

  def read_logs_from_file(file_path)
    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      exit
    end

    # https://stackoverflow.com/questions/39031541/how-to-read-a-large-text-file-line-by-line-and-append-this-stream-to-a-file-line
    File.foreach(file_path).map(&:strip).reject(&:empty?)
  end

  def parse_logs(logs)
    parsed_logs = []
    skipped_logs = []

    logs.each do |log|
      unless log.start_with?('VOTE')
        skipped_logs << "Skipped log: [#{log}] as it does not start with VOTE"
        next
      end

      vote_data = parse_log(log)

      unless valid_vote?(vote_data)
        skipped_logs << "Skipped log: [#{log}] as it does not contain the required data"
        next
      end

      parsed_logs << vote_data
    end

    [parsed_logs, skipped_logs]
  end

  def parse_log(log)
    fields = log.split(' ').drop(1)
    vote_data = {}

    fields.each_with_index do |field, index|
      if index.zero?
        vote_data['Timestamp'] = Time.at(field.strip.to_i).to_datetime
      else
        key, value = field.split(':')
        vote_data[key] = value
      end
    end

    vote_data
  end

  def valid_vote?(vote_data)
    required_keys_present?(vote_data) && required_values_present?(vote_data) && valid_validity_value?(vote_data)
  end

  def required_keys_present?(vote_data)
    (VALID_LOG_FORMAT - vote_data.keys).empty?
  end

  def required_values_present?(vote_data)
    vote_data.values_at(*VALID_LOG_FORMAT).all?(&:present?)
  end

  def valid_validity_value?(vote_data)
    vote_data['Validity'].in?(Vote::VALIDITY_VALUES)
  end

  def save_votes(vote_data_batch)
    # Many votes will belong to the same campaign and/or candidate. Considering
    # that there are much fewer campaigns and candidates in relation to votes,
    # we can avoid querying the database for campaigns and candidates on each vote
    # by storing the already existing campaign and candidate records in memory. 
    # We will first look at the cached records to see if that object has already 
    # been retrieved. If not, we will proceed to query the database and store the 
    # record in memory for future reference.

    campaigns_cache = {}
    candidates_cache = {}

    vote_data_batch.each do |vote_data|
      campaign = campaigns_cache[vote_data['Campaign']] ||= Campaign.find_or_create_by!(name: vote_data['Campaign'])
      candidate = candidates_cache[vote_data['Choice']] ||= Candidate.find_or_create_by!(name: vote_data['Choice'], campaign: campaign)

      Vote.create!(campaign: campaign, candidate: candidate, validity: vote_data['Validity'], voted_at: vote_data['Timestamp'])
    end
  rescue ActiveRecord::RecordInvalid => exception
    puts "Failed to save votes: #{exception}"
  end

  def display_skipped_logs(skipped_logs)
    puts "\nSkipped logs:\n\n"
    
    skipped_logs.each { |log| puts log }
  end
end
