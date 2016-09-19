class AnnotationsController < ApplicationController

  def index
    render json: {}
  end

  def show
    resource_id = annotation_prefix + params[:id]
    annotation = Annotation.find_by('resource_id' => resource_id)
    render json: annotation.data
  end

  def create
    annotation_params = annotation_from_params
    annotation_params['@id'] = annotation_prefix + SecureRandom.uuid
    annotation_json = JSON.pretty_generate annotation_params
    resource = annotation_params['resource']
    resource = resource[0] if resource.is_a?(Array)
    search_text = resource['chars']
    motivation = annotation_params['motivation'].to_s
    annotation_id = annotation_params['@id']
    annotation = Annotation.create(resource_id: annotation_id, data: annotation_json, search_text: search_text, motivation: motivation, active: true)
    target = Target.create(canvas: annotation_params['on']['full'], manifest: annotation_params['on']['within']['@id'])
    annotation.targets = [ target ]
    render json: annotation_params
  end

  def update
    annotation_params = annotation_from_params
    annotation = Annotation.find_by('resource_id' => annotation_params['@id'])
    annotation_json = JSON.pretty_generate annotation_params
    resource = annotation_params['resource']
    resource = resource[0] if resource.is_a?(Array)
    search_text = resource['chars']
    motivation = annotation_params['motivation'].to_s
    annotation_id = annotation_params['@id']
    annotation.update(resource_id: annotation_id, data: annotation_json, search_text: search_text, motivation: motivation, active: true)
    annotation.targets.clear
    annotation.targets.build(canvas: annotation_params['on']['full'], manifest: annotation_params['on']['within']['@id'])
    annotation.save
    render json: annotation_params
  end

  def destroy
    uri = annotation_prefix + params[:id]
    anno = Annotation.find_by(resource_id: uri)
    if anno
      anno.destroy
    else
      status = 404
    end
    render json: { '@id' => uri }
  end

  private

  def annotation_from_params
    added_parameters = ['controller', 'action', 'id', 'annotation', 'format']
    annotation = {}
    params.to_unsafe_hash.each_pair {|k,v|
      annotation[k] = v unless added_parameters.include?(k)
    }
    annotation
  end

  def annotation_prefix
    Rails.application.config.annotation_uri_template
  end

end
