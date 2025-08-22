# README

A Ruby on Rails application for tracking devices assigned to users.


Requirements:
- Ruby 3.2.3 
- Rails 7.x
- SQLite3
- Bundler

Setup:
1. Clone the repository:
   git clone https://github.com/witoldszgl/device-registry-assignment.git
   cd device-registry-assignment
2. Install dependencies:
   bundle install
3. Create and migrate the database:
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed   # optional, for sample data
4. Prepare the test database:
   rake db:test:prepare
5. Run the test suite:
   bundle exec rspec
6. Start the Rails server:
   bin/rails server
   The app will be available at http://localhost:3000

API Endpoints:
- POST /api/assign – Assign a device to a user
- POST /api/unassign – Return a device

For usage examples, see the specs in the spec folder - they demonstrate typical scenarios and expected behaviors.
