require 'test_helper'

describe PetsController do
  describe "index" do
    it "responds with JSON and success" do
      get pets_path
      
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :ok
    end
    
    it "responds with an array of pet hashes" do
      # Act
      get pets_path
      
      # Get the body of the response
      body = JSON.parse(response.body)
      
      # Assert
      expect(body).must_be_instance_of Array
      body.each do |pet|
        expect(pet).must_be_instance_of Hash
        expect(pet.keys.sort).must_equal ["age", "human", "id", "name"]
      end
    end
    it "will respond with an empty array when there are no pets" do
      # Arrange
      Pet.destroy_all
      
      # Act
      get pets_path
      body = JSON.parse(response.body)
      
      # Assert
      expect(body).must_be_instance_of Array
      expect(body).must_equal []
    end
  end
  
  describe "show" do
    it "will show pet info for valid pet" do
      test_pet = Pet.first
      get pet_path(test_pet)
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      must_respond_with :ok
      expect(body.keys.sort).must_equal ["age", "human", "id", "name"]
      expect(body["name"]).must_equal test_pet.name
      expect(body["id"]).must_equal test_pet.id
      expect(body["age"]).must_equal test_pet.age
      expect(body["human"]).must_equal test_pet.human
    end
    
    it "will show error code for invalid pet" do
      invalid_pet = -1
      get pet_path(invalid_pet)
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body["errors"]).must_equal ["not found"]
      must_respond_with :not_found
    end
    
  end
  
end
