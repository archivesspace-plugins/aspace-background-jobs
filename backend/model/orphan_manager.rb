module OrphanManager
  @@registered_orphans ||= {}


  def self.register_orphan(orphan_class, opts)
    opts[:code] = orphan_class.code
    opts[:model] = orphan_class
    opts[:params] ||= []

    Log.warn("Orphan with code '#{opts[:code]}' already registered") if @@registered_orphans.has_key?(opts[:code])

    @@registered_orphans[opts[:code]] = opts
  end


  def self.registered_orphans
    @@registered_orphans
  end


  module Mixin

    def self.included(base)
      base.extend(ClassMethods)
    end


    module ClassMethods

      def register_orphan(opts = {})
        OrphanManager.register_orphan(self, opts)
      end

    end
  end
end
