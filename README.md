# Game Backend API

A Ruby on Rails API backend for game-related functionality.

## Prerequisites

- Ruby 3.3.5
- PostgreSQL


## Setup Instructions

1. Open the folder:
   ```
   cd game_backend_api
   ```

2. Install dependencies:
   ```
   bundle install
   ```

3. Set up the database:
   ```
   # Create and setup the database
   rails db:create
   rails db:migrate
   
   # (Optional) Seed the database with initial data
   rails db:seed
   ```

4. Environment variables are committed to the repo. So, no need to set them.

## Running the Application

### Development Mode

Start the Rails server:
```
rails server
```

The API will be available at `http://localhost:3000`

### Running Tests

The project uses RSpec for testing. To run the test suite:

```
# Run all tests
bundle exec rspec


# Run tests with documentation format
bundle exec rspec --format documentation
```


## Project Structure

- `app/` - Contains the core application code
  - `controllers/` - API endpoints
  - `models/` - Database models
  - `services/` - Some Business logic
- `db/` - Database migrations and seeds
- `spec/` - Test files
