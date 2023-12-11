# Experience Exchange (Back-End)
## About
Experience Exchange was built with a core focus in mind - that of the ability to share experiences and knowledge with others. Want to learn to knit? Find a nearby knitting buddy who can pass on their years of knowledge! What about musical interest, piano perhaps? Search for your interests, and whether you'd like an in-person or remote buddy, and you're off to the races!

Experience Exchange is built on a Rails backend leveraging microservices, with a React/TypeScript frontend. The app is deployed via [Heroku](https://dashboard.heroku.com/login) for backend, and [Vercel](https://vercel.com/) for frontend.

<br>Link to [Frontend Repo](https://github.com/experience-exchange-2307/fe_experience_exchange)
<br>Link to [Image Microservice Repo](https://github.com/experience-exchange-2307/be_image_service)

## Contributors
**Backend**

- Antoine Aube - [GitHub](https://github.com/Antoine-Aube) || [LinkedIn](https://www.linkedin.com/in/antoineaube/)
- Ethan Bustamante - [GitHub](https://github.com/ethanb1145) || [LinkedIn](https://www.linkedin.com/in/ethan-bustamante/)
- Tyler Blackmon - [GitHub](https://github.com/tblackmon-tiel) || [LinkedIn](www.linkedin.com/in/tyler-blackmon/)

**Frontend**

- Devin Altobello - [GitHub](https://github.com/daltobello) || [LinkedIn](https://www.linkedin.com/in/devin-altobello-2100036b/)
- Jen Ziel - [GitHub](https://github.com/jenziel) || [LinkedIn](https://www.linkedin.com/in/jen-ziel400/)
- Marisa Wyatt - [GitHub](https://github.com/Marisa5280) || [LinkedIn](https://www.linkedin.com/in/marisarwyatt/)

## Technologies
Primary:
- Ruby 3.2.2
- Rails 7.0.8
- PostgreSQL

Production Gems:
- [jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer)
- [Faraday](https://lostisland.github.io/faraday/#/)

Testing Gems:
- [rspec-rails](https://github.com/rspec/rspec-rails)
- [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
- [FactoryBot](https://github.com/thoughtbot/factory_bot)
- [Faker](https://github.com/faker-ruby/faker)

## Installation/Setup
### Cloning and installing dependencies
- `git clone <repo_name>`
- `cd <repo_name>`
- `bundle install`
- `rails db:{drop,create,migrate}`

### Third Party APIs
Experience Exchange uses two third party APIs - [Geoapify](https://apidocs.geoapify.com/docs/geocoding/forward-geocoding/#about) for geocoding, and [Unsplash](https://unsplash.com/documentation) for randomized user images. Only Geoapify needs to be setup in the primary repo for geocoding of a user's address.

Follow the Geoapify documentation to get an API key, and place it in the rails credentials file as follows:
- `EDITOR="code --wait" rails credentials:edit`
```
geoapify:
  api_key: <YOUR_CLIENT_ID>
```

### Setting up data
The seed file already contains a small amount of test data that can be initialized with `rails db:seed`. Alternative data can be added via editing the seed file, or manual creation in the rails console (`rails c`).

- Users: first_name, last_name, email (unique), street, city, state, zip, is_remote, about (optional: lat, lon)<br>
`User.create(first_name: "Steve", last_name: "Jobs", email: "steve@gmail.com", street: "1234 Street", city: "Cupertino", state: "CA", zipcode: "12345", lat: "1.12", lon: "1.12", is_remote: "true", about: "I am a very good programmer")`

- Meetings: date, start_time, end_time, purpose<br>
`Meeting.create!(date: "2023-12-15", start_time: "07:30", end_time: "08:00", purpose: "testing")`

- Skills: name, proficiency, user_id<br>
`Skill.create!(name: "Testing", proficiency: 5, user_id: 1)`

- User_Meetings: user_id, meeting_id, is_requestor<br>
`UserMeeting.create!(user_id: 1, meeting_id: 1, is_requestor: true`

## Testing
There are two options for testing, either the existing test suite, or manual testing with Postman.
- Test suite: `bundle exec rspec`
- Postman: `rails s`, then test on http://localhost:3000

For full coverage of testing, the [image microservice](https://github.com/experience-exchange-2307/be_image_service) also needs to be running on port 5000. Please see further setup instructions for the microservice in that repo. Without it running, related tests for image generation will fail, though users will still be created with `nil` values in their `profile_picture`.

## Endpoints
**Fetch a User - GET /api/v1/users/id**
<details>
  <summary>Example Response</summary>
  
  ```json
  {
      "data": {
          "id": "13",
          "type": "user",
          "attributes": {
              "first_name": "Steve",
              "last_name": "Jobs",
              "email": "steve@gmail.com",
              "address": {
                  "street": "1234 Street",
                  "city": "Cupertino",
                  "state": "CA",
                  "zipcode": "12345"
              },
              "about": "I am a very good programmer",
              "lat": 1.12,
              "lon": 1.12,
              "is_remote": true,
              "skills": [
                  {
                      "name": "Apple",
                      "proficiency": 5
                  },
                  {
                      "name": "Swift",
                      "proficiency": 5
                  },
                  {
                      "name": "knitting",
                      "proficiency": 3
                  }
              ],
              "profile_picture": "some_url.com"
          }
      }
  }
  ```
</details>
<br>

**Fetch a User's Meetings - GET /api/v1/users/id/meetings**
<details>
  <summary>Example Response</summary>
  
  
  ```json
  {
      "data": [
          {
              "id": "2",
              "type": "user_meeting",
              "attributes": {
                  "date": "2023-12-15",
                  "start_time": "01:45 PM",
                  "end_time": "02:00 PM",
                  "is_accepted": null,
                  "purpose": "testing",
                  "partner_id": 20,
                  "is_host": true
              }
          },
          {
              "id": "3",
              "type": "user_meeting",
              "attributes": {
                  "date": "2023-12-16",
                  "start_time": "08:30 AM",
                  "end_time": "09:00 AM",
                  "is_accepted": null,
                  "purpose": "Learn about something!",
                  "partner_id": 147,
                  "is_host": true
              }
          }
      ]
  }
  ```
</details>
<br>

**Fetch a list of Users by skill - GET /api/v1/search_skills**
Params: query, user_id<br>
<details>
  <summary>Example Response</summary>
  
  ```json
  {
      "data": [
          {
              "id": "13",
              "type": "searched_user",
              "attributes": {
                  "first_name": "Steve",
                  "last_name": "Jobs",
                  "is_remote": true,
                  "skills": [
                      {
                          "name": "Apple",
                          "proficiency": 5
                      },
                      {
                          "name": "Swift",
                          "proficiency": 5
                      },
                      {
                          "name": "knitting",
                          "proficiency": 3
                      }
                  ],
                  "distance": 6650
              }
          }
      ]
  }
  ```
</details>
<br>

**Add skills to a user - POST /api/v1/add_skills**
<details>
  <summary>Expected Request Body</summary>
  
  ```json
    {
      "user_id": "1",
      "skills": [
        {
          "name": "skiing",
          "proficiency": "1"
        },
        {
          "name": "ping pong",
          "proficiency": "4"
        }
      ]
    }
  ```
</details>
<details>
  <summary>Example Response</summary>
  
  ```json
    {
        "data": {
            "id": "1",
            "type": "user",
            "attributes": {
                "first_name": "Nancy",
                "last_name": "Smith",
                "email": "nancy@test.com",
                "address": {
                    "street": "5925 Dublin Blvd Unit B",
                    "city": "Colorado Springs",
                    "state": "Colorado",
                    "zipcode": "80923"
                },
                "about": "A kind soul to share knitting!",
                "lat": 38.9259362930209,
                "lon": -104.7180106940249,
                "is_remote": false,
                "skills": [
                    {
                        "name": "Knitting",
                        "proficiency": 4
                    },
                    {
                        "name": "skiing",
                        "proficiency": 1
                    },
                    {
                        "name": "ping pong",
                        "proficiency": 4
                    }
                ]
            }
        }
    }
  ```
</details>
<br>

**Add a meeting between two Users - POST /api/v1/meetings**
<details>
  <summary>Expected Request Body</summary>
  
  ```json
  {
    "user_id": "1",
    "partner_id": "2",
    "date": "2023-12-15",
    "start_time": "07:30",
    "end_time": "08:30",
    "purpose": "free form text",
  }
  ```
</details>
<details>
  <summary>Example Response</summary>
  
  ```json
  {
      "data": {
          "id": "33",
          "type": "meeting",
          "attributes": {
              "date": "2023-12-15",
              "start_time": "07:30 AM",
              "end_time": "08:30 AM",
              "is_accepted": null,
              "purpose": "free form text",
              "partner_id": 300
          }
      }
  }
  ```
</details>
<br>

**Create a new User - POST /api/v1/users**
<details>
  <summary>Expected Request Body</summary>
  
  ```json
  {
      "first_name": "Fake",
      "last_name": "User",
      "email": "some_email@gmail.com",
      "street": "1234 Fake Address",
      "city": "Parker",
      "state": "CO",
      "zipcode": "80134",
      "is_remote": "true",
      "about": "I like turtles"
  }
  ```
</details>
<details>
  <summary>Example Response</summary>
  
  ```json
  {
      "data": {
          "id": "1065",
          "type": "user",
          "attributes": {
              "first_name": "Fake",
              "last_name": "User",
              "email": "some_email@gmail.com",
              "address": {
                  "street": "1234 Fake Address",
                  "city": "Parker",
                  "state": "CO",
                  "zipcode": "80134"
              },
              "about": "I like turtles",
              "lat": 39.5184514,
              "lon": -104.7612638,
              "is_remote": true,
              "skills": [],
              "profile_picture": "some_url.com"
          }
      }
  }
  ```
</details>

## Database Schema
```
ActiveRecord::Schema[7.0].define(version: 2023_12_08_212901) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "meetings", force: :cascade do |t|
    t.date "date"
    t.boolean "is_accepted"
    t.string "purpose"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "start_time"
    t.time "end_time"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.integer "proficiency"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_skills_on_user_id"
  end

  create_table "user_meetings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "meeting_id", null: false
    t.boolean "is_requestor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meeting_id"], name: "index_user_meetings_on_meeting_id"
    t.index ["user_id"], name: "index_user_meetings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.float "lat"
    t.float "lon"
    t.boolean "is_remote"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "about"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.string "street"
    t.string "profile_picture"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "skills", "users"
  add_foreign_key "user_meetings", "meetings"
  add_foreign_key "user_meetings", "users"
end
```
