## s3-mini-cli-ruby

S3のAPIを利用できるruby製の簡易CLIです。

### セットアップ

#### 1. bundle install

```
git clone git@github.com:rsym/s3-mini-cli-ruby.git
cd s3-mini-cli-ruby
bundle install --path vendor/bundle
```

#### 2. アクセスキーを環境変数に設定する

アクセスキーを環境変数に設定します。
`.env.sample`というファイルをコピーして`.env`を用意して編集してください。
```
cp .env.sample .env
vi .env

アクセスキーを記載する
AWS_ACCESS_KEY_ID='********************'
AWS_SECRET_ACCESS_KEY='***********************'
```

### USAGE

現時点で利用できるのは `GetObject`/`PutObject`/`DeleteObject`/`CopyObject`の4つだけです。

```
Usage: ./s3-mini-cli --api GetObject|PutObject|DeleteObject|CopyObject --bucket BUCKET --key PATH/TO/KEY [OPTIONS]

OPTIONS:
  --usage
  --region (default : us-east-1)
  --endpoint (default : https://s3.amazonaws.com/)
  --acl
  --response_target
  --source_file
  --copy_source
```

#### GetObjectの実行例

```
./s3-mini-cli --api GetObject --endpoint https://end.point.url/ --bucket bucket_name --key path/to/key --save_as /path/to/download
```
