require_relative '../error'

module CheckGlobalSyntaxHelper

    def self.error_shooter(line, message)
        error = Error.new(line)
        error.raise_closure_error(message)
    end
    
    def self.check_open_end(file)
        open_lines = 0
        close_lines = 0
        state = false
        file.lines.each do |line|
            if line.opening_line?
                open_lines += 1
            elsif line.closing_line?
                close_lines += 2
            end
        end
        last_line = file.lines[file.lines.length -1]
        if open_lines > close_lines
            state = self.error_shooter(last_line, "Missing a 'end' closure in this file")
        elsif open_lines < close_lines
            state = self.error_shooter(last_line, "Useless 'end' closure in this file")
        end
        state
    end

    def self.check_spaces(line)
        state = false
        pattern = Regexp.new("^[\s]+(class|module|require|require_relative)")
        if line.opening_line? && pattern.match?(line)
            state = self.error_shooter(line, "Useless space before class/module declaration")
        end 
        state
    end

end