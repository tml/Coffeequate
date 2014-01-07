define ["terminals", "nodes", "parse"], (terminals, nodes, parse) ->

	# Equation object to represent (terminal = expression).

	class Equation
		constructor: (args...) ->
			# Arguments should either be:
			# (string), which will be split into two strings by the = sign and parsed, or if there's no
			# = sign then it will be equated to 0;
			# (stringLeft, stringRight), which will be the left and right hand sides of the equation;
			# (Terminal, Terminal/BasicNode), which will be the left and right hand sides of the equation.
			# All else is an error.
			switch args.length
				when 1
					if args[0] instanceof String or typeof args[0] == "string"
						sides = args[0].split("=")
						switch sides.length
							when 1
								@left = new terminals.Constant("0")
								@right = parse.stringToExpression(sides[0])
							when 2
								@left = parse.stringToTerminal(sides[0])
								@right = parse.stringToExpression(sides[1])
							else
								throw new Error("Too many '=' signs.")
					else if args[0] instanceof terminals.Terminal or args[0] instanceof nodes.BasicNode
						@left = new terminals.Constant("0")
						@right = args[0].copy()
					else
						throw new Error("Argument must be a String, Terminal, or Node.")
				when 2
					if args[0] instanceof String or typeof args[0] == "string"
						@left = parse.stringToTerminal(args[0])
					else if args[0] instanceof terminals.Terminal or args[0] instanceof nodes.BasicNode
						@left = args[0].copy()
					else
						throw new Error("Argument must be a String, Terminal, or Node.")
					if args[1] instanceof String or typeof args[1] == "string"
						@right = parse.stringToExpression(args[1])
					else if args[1] instanceof terminals.Terminal or args[1] instanceof nodes.BasicNode
						@right = args[1].copy()
					else
						throw new Error("Argument must be a String, Terminal, or Node.")
				else
					throw new Error("Too many arguments.")

		solve: (variable) ->
			expr = new Add(@right, new Mul("-1", @left))
			return new Equation(variable, expr.solve(variable))

		replaceVariables: (replacements) ->
			@left.replaceVariables(replacements)
			@right.replaceVariables(replacements)

		getAllVariables: ->
			leftVars = @left.getAllVariables()
			rightVars = @right.getAllVariables()
			for variable in leftVars
				unless variable in rightVars
					rightVars.unshift(variable)

		sub: (substitutions) ->
			if @left instanceof terminals.Variable and @left.label of substitutions
				expr = new Add(@right, new Mul("-1", @left))
				return new Equation(expr.sub(substitutions))
			else
				return new Equation(@left, @right.sub(substitutions))

		substituteExpression: (source, variable, equivalencies) ->
			if @left instanceof terminals.Variable and @left.label of substitutions
				expr = new Add(@right, new Mul("-1", @left))
				return new Equation(expr.substituteExpression(source, variable, equivalencies))
			else
				return new Equation(@left, @right.substituteExpression(source, variable, equivalencies))

		toMathML: (equationID, expression=false, equality=null, topLevel=false) ->
			# equality is here for consistency and nothing else, so we ignore it.
			return @right.toMathML(equationID, expression, @left, topLevel)

		toHTML: (equationID, expression=false, equality=null, topLevel=false) ->
			# equality is here for consistency and nothing else, so we ignore it.
			return @right.toHTML(equationID, expression, @left, topLevel)

		toLaTeX: ->
			return "#{@left.toLaTeX()} = #{@right.toLaTeX()}"

		toString: ->
			return "#{left} = #{right}"

	return Equation