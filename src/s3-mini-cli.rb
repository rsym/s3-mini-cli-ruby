require 'aws-sdk-s3'
require 'dotenv'
require 'optparse'
require 'pp'

class S3api
  @s3_client

  def initialize(access_key_id, secret_access_key, region, endpoint)
    @s3_client = Aws::S3::Client.new(
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      region: region,
      endpoint: endpoint
    )
  end

  # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html#get_object-instance_method
  def getObject(bucket, key, api_parameters)
    begin
      result = @s3_client.get_object(
        bucket: bucket,
        key: key,
        response_target: api_parameters[:response_target]
      )
    rescue StandardError => e
      puts "Error: #{e.message}"
    end

    return result
  end

  # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html#put_object-instance_method
  def putObject(bucket, key, api_parameters)
    begin
      result = @s3_client.put_object(
        bucket: bucket,
        key: key,
        acl: api_parameters[:acl],
        body: api_parameters[:source_file]
      )
    rescue StandardError => e
      puts "Error: #{e.message}"
    end

    return result
  end

  # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html#delete_object-instance_method
  def deleteObject(bucket, key, api_parameters)
    begin
      result = @s3_client.delete_object(
        bucket: bucket,
        key: key
      )
    rescue StandardError => e
      puts "Error: #{e.message}"
    end

    return result
  end

  # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html#copy_object-instance_method
  def copyObject(bucket, key, api_parameters)
    begin
      result = @s3_client.copy_object(
        bucket: bucket,
        key: key,
        copy_source: api_parameters[:copy_source]
      )
    rescue StandardError => e
      puts "Error: #{e.message}"
    end

    return result
  end
end


def usage
  puts <<-EOS
Usage: ./s3-mini-cli --api GetObject|PutObject|DeleteObject|CopyObject --bucket BUCKET --key PATH/TO/KEY [OPTIONS]

OPTIONS:
  --usage
  --region (default : us-east-1)
  --endpoint (default : https://s3.amazonaws.com/)
  --acl
  --response_target
  --source_file
  --copy_source
EOS
end

def main
  params = ARGV.getopts(
    nil,
    "usage",
    "api:",
    "bucket:",
    "key:",
    "region:us-east-1",
    "endpoint:https://s3.amazonaws.com",
    "acl:private",
    "response_target:",
    "source_file:",
    "copy_source:"
  )

  if params['usage']
    usage
    exit
  end

  api = params['api']

  Dotenv.load ".env"
  region = params['region']
  endpoint = params['endpoint']
  access_key_id = ENV['AWS_ACCESS_KEY_ID']
  secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

  bucket = params['bucket']
  key = params['key']
  api_parameters = {}
  api_parameters[:acl] = params['acl']
  api_parameters[:response_target] = params['response_target']
  api_parameters[:source_file] = params['source_file']
  api_parameters[:copy_source] = params['copy_source']


  s3_client = S3api.new(access_key_id, secret_access_key, region, endpoint)

  case api
    when "GetObject" then
      result = s3_client.getObject(bucket, key, api_parameters)
      pp result
    when "PutObject" then
      result = s3_client.putObject(bucket, key, api_parameters)
      pp result
    when "DeleteObject" then
      result = s3_client.deleteObject(bucket, key, api_parameters)
      pp result
    when "CopyObject" then
      result = s3_client.copyObject(bucket, key, api_parameters)
      pp result
    else
      puts "#{api} is not supported."
      usage
  end
end


main if $PROGRAM_NAME == __FILE__
