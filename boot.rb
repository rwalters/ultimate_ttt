config  = File.expand_path('config/initializers',  File.dirname(__FILE__))
lib     = File.expand_path('lib',     File.dirname(__FILE__))

$LOAD_PATH.unshift(config) unless $LOAD_PATH.include?(config)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'json'
