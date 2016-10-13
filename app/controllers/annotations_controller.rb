class AnnotationsController < ApplicationController

  def index
    render json: {}
  end

  def show
    data = annotation_from_params
    render json: data
  end

  def create
    annotation = annotation_from_params
    annotation['@id'] = annotation_prefix + SecureRandom.uuid
    data = JSON.pretty_generate annotation
    resource = annotation['resource']
    resource = resource[0] if resource.is_a?(Array)
    search_text = resource['chars']
    motivation = annotation['motivation'].to_s
    annotation_id = annotation['@id']
    anno = Annotation.create(resource_id: annotation_id, data: data, search_text: search_text, motivation: motivation, active: true)
    target = Target.create(canvas: annotation['on']['full'], manifest: annotation['on']['within']['@id'])
    anno.targets = [ target ]
    render json: annotation
  end

  def update
    annotation = annotation_from_params
    anno = Annotation.find_by('resource_id' => annotation['@id'])
    data = JSON.pretty_generate annotation
    resource = annotation['resource']
    resource = resource[0] if resource.is_a?(Array)
    search_text = resource['chars']
    motivation = annotation['motivation'].to_s
    annotation_id = annotation['@id']
    anno.update(resource_id: annotation_id, data: data, search_text: search_text, motivation: motivation, active: true)
    anno.targets.clear
    anno.targets.build(canvas: annotation['on']['full'], manifest: annotation['on']['within']['@id'])
    anno.save
    render json: annotation
  end

  def destroy
    uri = annotation_prefix + params[:id]
    anno = Annotation.find_by(resource_id: uri)
    if anno
      anno.destroy
    else
      status = 404
    end
    render json: { '@id': uri }
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
    Rails.application.config.annotation_prefix
  end

end
