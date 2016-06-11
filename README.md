### Intro

Ứng dụng nhỏ bằng Ruby, sử dụng **Roda** (Routing tree web toolkit - dựa trên **CUBA** và inspired bởi **Sinatra**). UBrand Worklogs Assistant cung cấp các API để Dev Team của UBrand có thể log công việc mình đang làm bất cứ lúc nào bằng cách chat với Slack Bot. (Inspired by [EngineerMatchingLog](https://www.engineermatching.com))

Logs sẽ được tổng hợp và gửi đến Tech Lead/Project Manager hàng tuần.

### TODO

- Slack Bot??
- Tương tác với JIRA Cloud??

### How to run this app

#### Production

```
bundle exec rackup
```

Hoặc sử dụng cú pháp của **Puma**:

```
bundle exec puma -p 3000 -e production
```

#### Development

Auto reload khi codebase của Project có thay đổi - **rerun**:

```
rerun -- rackup --port 3000 config.ru
```

#### Environment

Sử dụng Dotenv để load một số thông tin từ file .env:

```
WORKLOG_SECRET="your_secret_hash"
RACK_ENV="development"
PG_USER="postgres"
PG_PASSWORD=""
PG_HOST="127.0.0.1"
WORKLOG_DATABASE="worklogs"
```