require "base64"

class SearchController < ApplicationController

  SEARCH_PREFIX = 'http://127.0.0.1:3000/search/'

  def index
    annotations = Annotation.joins(:targets).where(targets: {canvas: params[:canvas] }).distinct
    result = []
    annotations.each { |anno|
      result.push JSON.parse(anno.data.to_s)
    }
    render json: result
  end

  # Canvas: http://127.0.0.1:3000/search/aHR0cDovL21hbmlmZXN0cy5icml0aXNoYXJ0LnlhbGUuZWR1L2NhbnZhcy9iYS1vYmotMTQ3NC0wMDAxLXB1Yg==
  # Manifest:  http://127.0.0.1:3000/search/aHR0cDovL21hbmlmZXN0cy5icml0aXNoYXJ0LnlhbGUuZWR1L21hbmlmZXN0LzE0NzQ=
  # Expects params[:id] to be a base64 encoded representation of the canvas URI
  def show
    resource_id = Base64.decode64(params[:id])
    annotations = Annotation.joins(:targets).where(targets: {canvas: resource_id }).distinct
    if annotations.nil? or annotations.empty?
      annotations = Annotation.joins(:targets).where(targets: {manifest: resource_id }).distinct
    end

    json_annotations = []
    annotations.each{ |anno|
      json_annotations.push JSON.parse(anno.data)
    }

    result = {
        '@context': 'http://iiif.io/api/presentation/2/context.json',
        '@id': SEARCH_PREFIX + params[:id],
        '@type': 'sc:AnnotationList',
        'yale:target': resource_id,
        'resources': json_annotations
    }

    render json: result
  end

end
