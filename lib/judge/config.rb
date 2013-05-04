require 'singleton'

module Judge
  class Config
    include Singleton

    @@exposed = {}
    @@exposed_as = {}

    def expose(klass, *attributes)
      attrs = (@@exposed[klass] ||= [])
      attrs.concat(attributes).uniq!
    end

    def expose_with_alias(klass, alias_klass)
      @@exposed_as[alias_klass] = klass
    end

    def exposed
      @@exposed
    end

    def exposed_as
      @@exposed_as
    end

    def exposed?(klass, attribute)
      @@exposed.has_key?(klass) && @@exposed[klass].include?(attribute)
    end

    def exposed_as?(klass)
      @@exposed_as[klass] || nil
    end

    def unexpose(klass, *attributes)
      attributes.each do |a|
        @@exposed[klass].delete(a)
      end
      if attributes.empty? || @@exposed[klass].empty?
        @@exposed.delete(klass)
      end
    end
  end

  def self.config
    Config.instance
  end

  def self.configure(&block)
    Config.instance.instance_eval(&block)
  end
end