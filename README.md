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
bundle exec puma --config puma.rb -p 3000 -e production
```

#### Development

Auto reload khi codebase của Project có thay đổi - **rerun**:

```
rerun --pattern "**/*.{rb, yml, slim, jbuilder}" -- rackup --port 3000 config.ru
```

**IRB** - Ruby console:

```
rake irb_dev
rake irb_test
rake irb_prod
```

#### Environment Variables

Sử dụng Dotenv để load một số thông tin từ file .env:

```
WORKLOG_SECRET="your_secret_hash"
RACK_ENV="development"
PG_USER="postgres"
PG_PASSWORD=""
PG_HOST="127.0.0.1"
WORKLOG_DATABASE="worklogs"
```

### Tham khảo

- [Roda Sequel Stack](https://github.com/jeremyevans/roda-sequel-stack)
- [Up and Going in Roda: A Simple Ruby Blog](http://mrcook.uk/simple-roda-blog-tutorial)
- [Sequel Cheat sheet](https://github.com/jeremyevans/sequel/blob/master/doc/cheat_sheet.rdoc)