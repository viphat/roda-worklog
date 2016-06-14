### Intro

Ứng dụng Worklog viết bằng Ruby, sử dụng **Roda** (Routing tree web toolkit - dựa trên **CUBA** và **Sinatra**).

**UBrand Worklog Assistant** cung cấp các API để Dev Team của UBrand có thể log công việc mình đang làm bất cứ lúc nào bằng gửi lệnh qua Slack Commands. (Inspired by [EngineerMatchingLog](https://www.engineermatching.com))

Worklog sẽ được tổng hợp và gửi Mail đến Tech Lead/Project Manager vào thứ 6 hàng tuần.

### TODO

- Tương tác với JIRA Cloud?? (Chưa tìm hiểu, không biết JIRA Cloud có cung cấp API không)

### How to run this app

#### Production

```
bundle exec rackup
```

Hoặc sử dụng cú pháp của **Puma**:

```
bundle exec puma -C puma.rb -e production
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
WORKLOG_SECRET="your\_secret\_hash"
RACK_ENV="development"
PG_USER="postgres"
PG_PASSWORD=""
PG_HOST="127.0.0.1"
WORKLOG_DATABASE="worklogs"
SLACK\_TOKEN\_FOR\_VERIFY="YOUR\_SLACK\_COMMAND\_TOKEN"
SLACK\_TOKEN\_FOR\_POST\_LOGS="YOUR\_SLACK\_COMMAND\_TOKEN"
```

### Tham khảo

- [Roda Sequel Stack](https://github.com/jeremyevans/roda-sequel-stack)
- [Up and Going in Roda: A Simple Ruby Blog](http://mrcook.uk/simple-roda-blog-tutorial)
- [Sequel Cheat sheet](https://github.com/jeremyevans/sequel/blob/master/doc/cheat_sheet.rdoc)