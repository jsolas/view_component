# frozen_string_literal: true

# Run `bundle exec rake benchmark` to execute benchmark.
# This is very much a work-in-progress. Please feel free to make/suggest improvements!

require "benchmark/ips"

# Configure Rails Environment
ENV["RAILS_ENV"] = "production"
require File.expand_path("../test/sandbox/config/environment.rb", __dir__)

Rails.logger.level = 1

module Performance
  require_relative "components/name_component"
  require_relative "components/nested_name_component"
  require_relative "components/inline_component"
end

class BenchmarksController < ActionController::Base
end

BenchmarksController.view_paths = [File.expand_path("./views", __dir__)]
controller_view = BenchmarksController.new.view_context

Benchmark.ips do |x|
  x.time = 10
  x.warmup = 2

  x.report("component") { controller_view.render(Performance::NameComponent.new(name: "Fox Mulder")) }
  x.report("inline") { controller_view.render(Performance::InlineComponent.new(name: "Fox Mulder")) }
  x.report("partial") { controller_view.render("partial", name: "Fox Mulder") }

  x.compare!
end
