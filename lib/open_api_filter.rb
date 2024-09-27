# frozen_string_literal: true

require 'json'
require 'yaml'

class OpenApiFilter
  attr_reader :file_path, :openapi_data

  # Initialize with the OpenAPI file path, supports both JSON and YML files
  def initialize(file_path)
    @file_path = file_path
    @openapi_data = load_file(file_path)
  end

  # Filter method that returns the filtered OpenAPI based on a regex pattern
  # rubocop:disable Metrics/MethodLength
  def filter(regex_pattern)
    # Select paths matching the regular expression
    filtered_paths = @openapi_data['paths'].select do |path, _details|
      path.match(regex_pattern)
    end

    # Collect associated tags and components used in the filtered paths
    used_tags = []
    used_components = []

    filtered_paths.each_value do |methods|
      methods.each_value do |operation|
        # Collect tags
        used_tags.concat(operation['tags']) if operation['tags']

        # Collect components from requestBody, responses, and parameters
        if operation['requestBody'] && operation['requestBody']['content']
          used_components.concat(collect_components_from_content(operation['requestBody']['content']))
        end

        if operation['responses'].present?
          operation['responses'].each_value do |response|
            used_components.concat(collect_components_from_content(response['content'])) if response['content']
          end
        end

        Array.wrap(operation['parameters']).each do |parameter|
          ref = parameter.dig('schema', '$ref') || parameter['$ref']
          used_components << extract_component_name(ref) if ref.present?
        end
      end
    end

    # Remove duplicate tags and components
    used_tags.uniq!
    used_components.uniq!

    # Filter components to only include those that are referenced
    filtered_components = filter_components(used_components)

    # Construct the new filtered OpenAPI object
    {
      'openapi'    => @openapi_data['openapi'],
      'info'       => @openapi_data['info'],
      'paths'      => filtered_paths,
      'tags'       => @openapi_data['tags'].select { |tag| used_tags.include?(tag['name']) },
      'components' => filtered_components
    }
  end
  # rubocop:enable Metrics/MethodLength

  # Export the filtered JSON/YAML to a new file
  def export(regex_pattern, new_file_path)
    filtered_data = filter(regex_pattern)

    # Write to the new file in the appropriate format (JSON or YAML)
    File.write(new_file_path, generate_file_content(new_file_path, filtered_data))
  end

  private

  # Load the file as JSON or YAML based on the file extension
  def load_file(file_path)
    ext = File.extname(file_path).downcase
    case ext
    when '.json'
      JSON.parse(File.read(file_path))
    when '.yml', '.yaml'
      YAML.safe_load_file(file_path)
    else
      raise "Unsupported file format: #{ext}. Please provide a .json, .yml, or .yaml file."
    end
  end

  # Generate the file content in either JSON or YAML format
  def generate_file_content(file_path, data)
    ext = File.extname(file_path).downcase
    case ext
    when '.json'
      JSON.pretty_generate(data)
    when '.yml', '.yaml'
      YAML.dump(data)
    else
      raise "Unsupported output format: #{ext}. Please provide a .json, .yml, or .yaml file."
    end
  end

  # Helper method to collect components from content section (e.g., requestBody, responses)
  def collect_components_from_content(content)
    components = []
    content.each_value do |media_type|
      if media_type['schema'] && media_type['schema']['$ref']
        components << extract_component_name(media_type['schema']['$ref'])
      end
    end
    components
  end

  # Extract component name from a $ref string, e.g., '#/components/schemas/MyComponent'
  def extract_component_name(ref_string)
    ref_string.split('/').last
  end

  # Filter components to only include the ones used in the filtered paths
  def filter_components(used_components)
    return {} unless @openapi_data['components'] && @openapi_data['components']['schemas']

    # Filter schemas in the components section
    filtered_schemas = @openapi_data['components']['schemas'].select do |component_name, _schema|
      used_components.include?(component_name)
    end

    # You can expand this logic to other components (e.g., responses, parameters, etc.)
    {
      'schemas' => filtered_schemas
    }
  end
end
