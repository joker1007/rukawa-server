require 'ripper'

class Rukawa::Server::JobDefinition
  attr_reader :source_code, :lineno, :file

  def initialize(job_class)
    @job_class = job_class
    run_method = job_class.instance_method(:run)
    @file, @run_method_line = run_method.source_location
  end

  def search_source_code
    if File.exist?(@file)
      lines = File.readlines(@file)
      sexp = Ripper.sexp(lines.join)
      location = traverse(sexp)
      if location
        leaf_level_pos = location[1].pop
        parent = location[1].inject(sexp) do |s, pos|
          s[pos]
        end
        start_next_stmt = nil
        next_stmt = parent[leaf_level_pos + 1]
        if next_stmt
          start_next_stmt = search_first_token_line(next_stmt)
        end

        end_lineno = start_next_stmt ? start_next_stmt - 2 : -1
        def_lines = lines[(location[0] - 1)..end_lineno]
        until Ripper.sexp(def_lines.join)
          def_lines.pop
        end
        @source_code = def_lines.join
        @lineno = location[0]
        true
      end
    end
  end

  def traverse(sexp, namespaces = [], current = [])
    case sexp[0]
    when :program
      sexp[1].each_with_index do |s, i|
        result = traverse(s, namespaces, current + [1, i] )
        return result if result
      end

      return nil
    when :module
      # :module -> :const_ref -> :@const
      mod_name = sexp[1][1][1]
      bodystmt, idx = get_bodystmt_with_idx(sexp)
      bodystmt[1].each_with_index do |s, i|
        result = traverse(s, namespaces + [mod_name], current + [idx, i])
        return result if result
      end

      return nil
    when :class
      # :class -> :const_ref -> :@const
      class_name = sexp[1][1][1]
      if (namespaces + [class_name]).join("::") == @job_class.to_s
        return sexp[1][1][2][0], current
      else
        bodystmt, idx = get_bodystmt_with_idx(sexp)
        bodystmt[1].each_with_index do |s, i|
          result = traverse(s, namespaces + [mod_name], current + [idx, i])
          return result if result
        end

        return nil
      end
    end
  end

  def search_first_token_line(sexp)
    case sexp[0]
    when Array
      sexp.each do |s|
        result = search_first_token_line(s)
        return result if result
      end
    when Symbol
      if sexp[0].to_s[0] == ?@
        return sexp[2][0]
      else
        if sexp[1]
          search_first_token_line(sexp[1])
        end
      end
    end
  end

  def get_bodystmt_with_idx(sexp)
    bodystmt_idx = sexp.index { |s| s && s[0] == :bodystmt }
    bodystmt = sexp[bodystmt_idx]
    return bodystmt, bodystmt_idx
  end
end
