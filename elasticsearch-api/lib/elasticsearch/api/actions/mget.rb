module Elasticsearch
  module API
    module Actions

      # Return multiple documents from one or more indices in a single request.
      #
      # Pass the request definition in the `:body` argument, either as an Array of `docs` specifications,
      # or `ids`, when the `:index` and document `:type` are specified.
      #
      # @example Get multiple documents fully specified in the `docs` definition
      #
      #     client.mget body: {
      #       docs: [
      #         { _index: 'myindex', _type: 'mytype', _id: '1' },
      #         { _index: 'myindex', _type: 'mytype', _id: '2' },
      #         { _index: 'myindex', _type: 'mytype', _id: '3' }
      #       ]
      #     }
      #
      # @example Get multiple documents specified by `ids` while passing `:index` and `:type`
      #
      #     client.mget index: 'myindex', type: 'mytype', body: { ids: ['1', '2', '3'] }
      #
      # @example Get only specific fields from documents
      #
      #     client.mget index: 'myindex', type: 'mytype', body: { ids: ['1', '2', '3'] }, fields: ['title']
      #
      # @option arguments [String] :index The name of the index
      # @option arguments [String] :type The type of the document
      # @option arguments [Hash] :body Document identifiers; can be either `docs` (containing full document information)
      #                                or `ids` (when index and type is provided in the URL (*Required*)
      # @option arguments [List] :fields A comma-separated list of fields to return in the response
      # @option arguments [String] :parent The ID of the parent document
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [Boolean] :realtime Specify whether to perform the operation in realtime or search mode
      # @option arguments [Boolean] :refresh Refresh the shard containing the document before performing the operation
      # @option arguments [String] :routing Specific routing value
      #
      # @see http://elasticsearch.org/guide/reference/api/multi-get/
      #
      def mget(arguments={})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        method = 'GET'
        path   = Utils.__pathify( arguments[:index], arguments[:type], '_mget' )
        params = arguments.select do |k,v|
          [ :fields,
            :parent,
            :preference,
            :realtime,
            :refresh,
            :routing ].include?(k)
        end
        # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
        params = Hash[params] unless params.is_a?(Hash)

        params[:fields] = Utils.__listify(params[:fields]) if params[:fields]

        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end