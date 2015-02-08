# -*- coding: UTF-8 -*-

class YopException < Exception; end

# Raised when get_template fails to find a template
class NonExistentTemplate < YopException; end

# Raised when a template variable is undefined
class UndefinedTemplateVariable < YopException; end

# Raised when a template variable has a wrong value
class BadTemplateVariableValue < YopException; end
