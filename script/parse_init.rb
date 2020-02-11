#!/usr/bin/env ruby

require 'rdf'
require 'linkeddata'
require 'httparty'

SEMCON_ONTOLOGY = "http://w3id.org/semcon/ns/ontology#"

# file=File.open("test.trig")
# init_input = file.readlines.join("")
# file.close

init_input = ARGV.pop
init = RDF::Repository.new()
init << RDF::Reader.for(:trig).new(init_input.to_s)

mapping = nil
init.each_graph{ |g| g.graph_name == SEMCON_ONTOLOGY + "DataMapping" ? mapping = g : nil }
File.write('/usr/src/app/config/mapping.ttl', mapping.dump(:trig).strip.split("\n")[1..-2].join("\n").strip)

ontology = nil
init.each_graph{ |g| g.graph_name == SEMCON_ONTOLOGY + "DataModel" ? ontology = g : nil }
if ontology.nil?
	File.write('/usr/src/app/config/ontology.ttl', "")
else	
	File.write('/usr/src/app/config/ontology.ttl', ontology.dump(:trig).strip.split("\n")[1..-2].join("\n").strip)
end

constraint = nil
init.each_graph{ |g| g.graph_name == SEMCON_ONTOLOGY + "DataConstraint" ? constraint = g : nil }
if constraint.nil?
	File.write('/usr/src/app/config/constraint.ttl', "")
else
	File.write('/usr/src/app/config/constraint.ttl', constraint.dump(:trig).strip.split("\n")[1..-2].join("\n").strip)
end

base_config = nil
init.each_graph{ |g| g.graph_name == SEMCON_ONTOLOGY + "BaseConfiguration" ? base_config = g : nil }
data_url = RDF::Query.execute(base_config) { pattern [:subject, RDF::URI.new(SEMCON_ONTOLOGY + "hasDataLocation"), :value] }.first.value.to_s.strip

File.write('/usr/src/app/config/data_url', data_url.to_s)
