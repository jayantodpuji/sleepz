# Sleepz

Sleepz is a Rails API application that helps users track their sleep patterns and follow other users' sleep records. Users can log their sleep and wake times, view their sleep duration, and follow other users to see their sleep patterns.

## Features

- User sleep tracking
  - Record sleep and wake times
  - Automatic duration calculation
- Social features
  - Follow other users
  - View timeline of followed users' sleep records

## System Requirements

- Ruby 3.x
- Rails 7.1
- PostgreSQL

## How To Run

1. Clone the repository
```bash
git clone https://github.com/jayantodpuji/sleepz
cd sleepz
```

2. Install dependencies
```bash
bundle install
```

3. Setup database
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. Start the server
```bash
rails server
```

## How To Run via Docker
```bash
git clone https://github.com/jayantodpuji/sleepz
cd sleepz
docker-compose up --build
```

## API Endpoints

### User Actions

#### Create Sleep Record
```http
POST /api/v1/user_actions
```

Parameters:
```json
{
  "user_id": "integer",
  "user_action": "string",
  "user_action_time": "datetime (ISO 8601)"
}
```

### Follow System

#### Follow a User
```http
POST /api/v1/follows
```

Parameters:
```json
{
  "follower_id": "integer",
  "followed_id": "integer"
}
```

### Users

#### List Users
```http
GET /api/v1/users
```

#### Get User Timeline
```http
GET /api/v1/users/:id/timeline
```

Query Parameters:
- `page`: Integer (default: 1)
- `per`: Integer (default: 10)

Response:
```json
{
  "data": [
    {
      "id": "string",
      "type": "sleep_record",
      "attributes": {
        "duration_in_second": "integer",
        "user_display_name": "string",
        "created_at": "datetime"
      }
    }
  ],
  "meta": {
    "pagination": {
      "current_page": "integer",
      "next_page": "integer",
      "prev_page": "integer",
      "total_pages": "integer",
      "total_count": "integer"
    }
  }
}
```

## Running Tests
```bash
bundle exec rspec
```

## Access The Web App

When you are already running the server, you can access it in `localhost:3000/index.html`

## Testing via Postman

You can export the [collection](sleepz.postman_collection.json) to your postman client

