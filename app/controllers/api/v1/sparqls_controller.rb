module Api
    module V1
        class SparqlsController < ApiController
            def status
                render plain: HTTParty.get("http://localhost:2806/api/sparql/status").parsed_response,
                       status: 200
            end

            def ontology
                render json: HTTParty.get("http://localhost:2806/api/sparql/ontology").parsed_response,
                       status: 200
            end

            def query
                render json: HTTParty.get("http://localhost:2806/api/sparql/query?" + request.query_string).parsed_response,
                       status: 200
            end

            def query_p

            end
        end
    end
end