# Game Backend API

A Ruby on Rails API backend for game-related functionality.


## Design decisions
The philosophy of this Backend server is to be be a reliable, and clear to clients. At the same time prevent clients of bad actors from attacking the server.

### Top level
- Error responses are standardized to keep client side logic uniform expecations
- Controllers are kept thin. Moving bulk of the logic to models, presenters and services.

### Authentication
- Signup EP returns the token so that a new user can be logged in in one request
- Sign in endpoint is rate limited to prevent brute-force attacks
- Using bcrypt, strong password for password security

### Game event capture
- The payload is validated and useful error messages are returned

### Subscription lookup
- If user is not found, we return a non blocking status so that user can view rest of the details
- If the service is failing temporarily we retry with exponential back off

Note: I've sprewn the code with notes. Search for "Note:" to find them all.


## Setup Instructions
Prerequisites: Ruby 3.3.5, PostgreSQL 

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
