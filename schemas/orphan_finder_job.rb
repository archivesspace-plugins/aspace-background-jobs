{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",

    "properties" => {

      "orphan_type" => {
        "type" => "string", 
        "if_missing" => "error"
      },

      "format" => {
        "type" => "string"
      }

    }
  }
}
