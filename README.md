# palai-basic-income-claim

Claim your [Palai](https://palai.org/) basic income automatically.

Reports your balance on stdout and as a TeamCity build statistic (only if you
run TeamCity).

## Usage

1. Install Ruby
1. Install bundler: `gem install bundler`
1. Download code and install dependencies

    ```sh
    git clone https://github.com/agross/palai-basic-income-claim.git
    cd palai-basic-income-claim.git
    bundle install
    ```

1. Run this script every day

    ```sh
    $ PALAI_USER=you@example.com PALAI_PASSWORD='secret' bundle exec ./palai.rb
    1234.5
    ```
