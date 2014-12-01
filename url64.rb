require "base64"
require "sass"

module Sass::Script::Functions
    def convertToB64(file_path)
        assert_type file_path, :String

        # compute file/path/extension
        base_path = "../../.."
        root = File.expand_path(base_path, __FILE__)
        path = file_path.to_s[4,file_path.to_s.length-5]
        fullpath = File.expand_path(path, root)

        # base64 encode the file
        file = File.open(fullpath, "rb")
        text = file.read
        file.close
        text_b64 = Base64.encode64(text).gsub(/\r/,"").gsub(/\n/,"")

        return text_b64

    end
    def str64(file_path)
        assert_type file_path, :String
        Sass::Script::String.new(convertToB64(file_path))
    end
    def url64(file_path)
        assert_type file_path, :String

        # compute file/path/extension
        path = file_path.to_s[4,file_path.to_s.length-5]
        ext = File.extname(path)

        if ext == ".svg"
            ext = ext + "+xml"
        end

        contents = "url(data:image/" + ext[1,ext.length-1] + ";base64," + convertToB64(file_path) + ")"

        Sass::Script::String.new(contents)
    end
    declare :url64, :args => [:string]
    declare :str64, :args => [:string]
end