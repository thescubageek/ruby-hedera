require 'test_helper'

class OpenApiFilterTest < Minitest::Test
  def setup
    # Common sample data for tests
    @sample_openapi_data = {
      "openapi" => "3.0.0",
      "info" => {
        "title" => "Sample API",
        "version" => "1.0.0"
      },
      "paths" => {
        "/pets" => {
          "get" => {
            "tags" => ["pets"],
            "summary" => "List all pets",
            "responses" => {
              "200" => {
                "description" => "A paged array of pets",
                "content" => {
                  "application/json" => {
                    "schema" => {
                      "$ref" => "#/components/schemas/Pets"
                    }
                  }
                }
              }
            }
          }
        },
        "/pets/{petId}" => {
          "get" => {
            "tags" => ["pets"],
            "summary" => "Info for a specific pet",
            "parameters" => [
              {
                "name" => "petId",
                "in" => "path",
                "required" => true,
                "schema" => {
                  "type" => "string"
                }
              }
            ],
            "responses" => {
              "200" => {
                "description" => "Expected response to a valid request",
                "content" => {
                  "application/json" => {
                    "schema" => {
                      "$ref" => "#/components/schemas/Pet"
                    }
                  }
                }
              }
            }
          }
        },
        "/users" => {
          "get" => {
            "tags" => ["users"],
            "summary" => "List all users",
            "responses" => {
              "200" => {
                "description" => "A paged array of users",
                "content" => {
                  "application/json" => {
                    "schema" => {
                      "$ref" => "#/components/schemas/Users"
                    }
                  }
                }
              }
            }
          }
        }
      },
      "tags" => [
        {
          "name" => "pets",
          "description" => "Operations about pets"
        },
        {
          "name" => "users",
          "description" => "Operations about users"
        }
      ],
      "components" => {
        "schemas" => {
          "Pet" => {
            "type" => "object",
            "required" => ["id", "name"],
            "properties" => {
              "id" => {
                "type" => "integer",
                "format" => "int64"
              },
              "name" => {
                "type" => "string"
              },
              "tag" => {
                "type" => "string"
              }
            }
          },
          "Pets" => {
            "type" => "array",
            "items" => {
              "$ref" => "#/components/schemas/Pet"
            }
          },
          "User" => {
            "type" => "object",
            "required" => ["id", "username"],
            "properties" => {
              "id" => {
                "type" => "integer",
                "format" => "int64"
              },
              "username" => {
                "type" => "string"
              },
              "email" => {
                "type" => "string",
                "format" => "email"
              }
            }
          },
          "Users" => {
            "type" => "array",
            "items" => {
              "$ref" => "#/components/schemas/User"
            }
          }
        }
      }
    }
  end

  test "initialization with JSON file" do
    # Create a temporary JSON file with sample OpenAPI data
    Tempfile.create(['sample', '.json']) do |file|
      file.write(JSON.pretty_generate(@sample_openapi_data))
      file.flush

      # Initialize OpenApiFilter with the file path
      filter = OpenApiFilter.new(file.path)

      # Assert that openapi_data is correctly loaded
      assert_equal @sample_openapi_data, filter.openapi_data
    end
  end

  test "initialization with YAML file" do
    # Create a temporary YAML file with sample OpenAPI data
    Tempfile.create(['sample', '.yaml']) do |file|
      file.write(YAML.dump(@sample_openapi_data))
      file.flush

      # Initialize OpenApiFilter with the file path
      filter = OpenApiFilter.new(file.path)

      # Assert that openapi_data is correctly loaded
      assert_equal @sample_openapi_data, filter.openapi_data
    end
  end

  test "initialization with invalid file extension raises error" do
    # Create a temporary file with unsupported extension
    Tempfile.create(['sample', '.txt']) do |file|
      # Try to initialize with this file
      assert_raises(RuntimeError) do
        OpenApiFilter.new(file.path)
      end
    end
  end

  test "filter with matching paths" do
    # Create a temporary JSON file with sample OpenAPI data
    Tempfile.create(['sample', '.json']) do |file|
      file.write(JSON.pretty_generate(@sample_openapi_data))
      file.flush

      # Initialize OpenApiFilter with the file path
      filter = OpenApiFilter.new(file.path)

      # Call filter with regex that matches '/pets' paths
      regex_pattern = /^\/pets/
      filtered_data = filter.filter(regex_pattern)

      # Expected filtered paths
      expected_paths = {
        "/pets" => @sample_openapi_data["paths"]["/pets"],
        "/pets/{petId}" => @sample_openapi_data["paths"]["/pets/{petId}"]
      }

      # Expected used tags
      expected_tags = [{ "name" => "pets", "description" => "Operations about pets" }]

      # Expected used components
      expected_components = {
        "schemas" => {
          "Pet" => @sample_openapi_data["components"]["schemas"]["Pet"],
          "Pets" => @sample_openapi_data["components"]["schemas"]["Pets"]
        }
      }

      # Assert that filtered_data has expected paths
      assert_equal expected_paths, filtered_data["paths"]

      # Assert that filtered_data has expected tags
      assert_equal expected_tags, filtered_data["tags"]

      # Assert that filtered_data has expected components
      assert_equal expected_components, filtered_data["components"]
    end
  end

  test "filter with no matching paths" do
    # Create a temporary JSON file with sample OpenAPI data
    Tempfile.create(['sample', '.json']) do |file|
      file.write(JSON.pretty_generate(@sample_openapi_data))
      file.flush

      # Initialize OpenApiFilter with the file path
      filter = OpenApiFilter.new(file.path)

      # Call filter with regex that matches no paths
      regex_pattern = /^\/nonexistent/
      filtered_data = filter.filter(regex_pattern)

      # Expected empty paths
      expected_paths = {}

      # Expected empty tags and components
      expected_tags = []
      expected_components = {}

      # Assert that filtered_data has empty paths
      assert_equal expected_paths, filtered_data["paths"]

      # Assert that filtered_data has empty tags
      assert_equal expected_tags, filtered_data["tags"]

      # Assert that filtered_data has empty components
      assert_equal expected_components, filtered_data["components"]
    end
  end

  test "export writes correct data" do
    # Create a temporary JSON file with sample OpenAPI data
    Tempfile.create(['sample', '.json']) do |input_file|
      input_file.write(JSON.pretty_generate(@sample_openapi_data))
      input_file.flush

      # Initialize OpenApiFilter with the file path
      filter = OpenApiFilter.new(input_file.path)

      # Create a temporary output file
      Tempfile.create(['filtered', '.json']) do |output_file|
        # Call export method
        regex_pattern = /^\/pets/
        filter.export(output_file.path, regex_pattern)

        # Read the output file
        output_data = JSON.parse(File.read(output_file.path))

        # Expected filtered data
        expected_paths = {
          "/pets" => @sample_openapi_data["paths"]["/pets"],
          "/pets/{petId}" => @sample_openapi_data["paths"]["/pets/{petId}"]
        }

        expected_tags = [{ "name" => "pets", "description" => "Operations about pets" }]

        expected_components = {
          "schemas" => {
            "Pet" => @sample_openapi_data["components"]["schemas"]["Pet"],
            "Pets" => @sample_openapi_data["components"]["schemas"]["Pets"]
          }
        }

        expected_filtered_data = {
          "openapi" => @sample_openapi_data["openapi"],
          "info" => @sample_openapi_data["info"],
          "paths" => expected_paths,
          "tags" => expected_tags,
          "components" => expected_components
        }

        # Assert that output data matches expected filtered data
        assert_equal expected_filtered_data, output_data
      end
    end
  end
end
