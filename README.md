# SimpleSubscriptionApi

Project setup:

1. `bundle`
2. `rake db:setup`
3. `raek db:migrate`
4. `rails c`

Run tests (_few tests still todo_):

`bundle exec rspec`

Code coverage:

`http://localhost:63342/SimpleSubscriptionAPI/coverage/index.html`

or in folder:

`coverage/index.html`

Static code analyzer:

`rubocop`

`rails_best_practices .`


### Example create request:

`
curl -X POST
  http://localhost:3000/api/v1/subscription
  -H 'Authorization: Basic c3VwZXI6ZHVwZXI='
  -H 'Cache-Control: no-cache'
  -H 'Content-Type: application/json'
  -d '{
	"subscription": {
		"name": "Steam",
		"credit_card": "6010430241237266856",
		"period": 120
	}
}'
`


### Example index request:

`
curl -X GET
  http://localhost:3000/api/v1/subscription
  -H 'Authorization: Basic c3VwZXI6ZHVwZXI='
  -H 'Cache-Control: no-cache'
  -H 'Content-Type: application/json'
`
