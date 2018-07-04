class Calculation
require 'ruby_parser'

  def evaluate_arithmetic_expression(expr)
    return 'Invalid input' if expr.nil? || expr == ''

    begin
      parse_tree = RubyParser.new.parse(expr)  # Sexp < Array
      result = evaluate_parse_tree(parse_tree).to_s
      # binding.pry
      if /^-?\d+$/ =~ result || result.to_f % 1 == 0
        result.to_i
      elsif /^-?\d+\.\d+$/ =~ result 
        # as per the given test case in doc program should round for 2 decimals 
        result.to_f.round(2)
      else
        "Invalid input"
      end
    rescue 
      return 'Invalid input'
    end
  end

  def evaluate_parse_tree(parse_tree)
    case parse_tree[0]
    when :lit
      return parse_tree[1]
    when :call
      meth = parse_tree[2]
      if [:+, :*, :-, :/].include? meth
        val = evaluate_parse_tree parse_tree[1]
        arglist = evaluate_parse_tree parse_tree[3]
              # binding.pry
        return val.send(meth, *arglist.to_f)
      else
        throw 'Unsafe'
      end
    when :arglist
      # binding.pry
      args = parse_tree[1..-1].map {|sexp| evaluate_parse_tree(sexp) }

      return args
    end
  end
end