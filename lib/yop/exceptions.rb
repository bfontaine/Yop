# -*- coding: UTF-8 -*-

# Base exception for Yop-related ones
class YopException < Exception; end

# Raised when get_template fails to find a template
class NonExistentTemplate < YopException; end

# Raised when a template variable is undefined
class UndefinedTemplateVariable < YopException; end

# Raised when a dynamic template variable is undefined
class UndefinedDynamicTemplateVariable < UndefinedTemplateVariable; end

# Raised when a template variable has a wrong value
class BadTemplateVariableValue < YopException; end

# Raised when a template contains an unsupported file type
class UnsupportedFileType < YopException; end
