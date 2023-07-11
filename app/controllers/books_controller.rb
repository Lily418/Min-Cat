class BooksController < ApplicationController

  def create_library_metadata
    YAML.load_file(File.join(Rails.root, 'app', 'assets', 'catalogue', 'metadata.yaml'))
  end

  def create_reader
    MARC::Reader.new(File.join(Rails.root, 'app','assets', 'catalogue', 'cat.marc'))
  end

  def map_marc_to_hash(record)
    {
      "id" => record["001"]&.value,
      "isbn" => record["020"]&.value,
      "title" => record["245"]&.value,
      "summary" => record["520"]&.value
    }
  end

  def index
    @metadata = create_library_metadata
    @books = create_reader().map { |record| puts record; map_marc_to_hash(record) }
  end

  def show
    puts create_reader()
    @book = map_marc_to_hash(create_reader().find { |record| record["001"].value == params[:id] })
  end
end
