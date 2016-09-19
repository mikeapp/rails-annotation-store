require 'rails_helper'

RSpec.describe AnnotationsController, type: :controller do

  describe '#create' do

    let(:svg_single_anno) { IO.read(Rails.root.join("spec", "json", "anno1.json")) }
    let(:data) { JSON.parse(svg_single_anno) }
    let(:annotation_uri_prefix) { Rails.application.config.annotation_uri_template }

    def json_content_type
      request.env['CONTENT_TYPE'] = 'application/json'
    end

    before(:each) do
      json_content_type
      request.env['RAW_POST_DATA'] = svg_single_anno
      post :create
      @response_json = JSON.parse(response.body)
    end

    if 'receives an @id after POST'
      expect(@response_json['@id']).to be
    end

    it 'saves a Mirador annotation with SVG' do
      anno = Annotation.find_by(resource_id: @response_json['@id'])
      expect(anno).to be
      expect(anno.data).to be
      expect(anno.targets.size).to eq 1
      expect(anno.targets.first.canvas).to eq data['on']['full']
      expect(anno.targets.first.manifest).to eq data['on']['within']['@id']
    end

    it 'round trips an annotation' do
      # extract the id needed to issue the GET
      original_resource_uri = @response_json['@id']
      id = original_resource_uri.gsub(annotation_uri_prefix, '')
      # GET the annotation to confirm round trip
      json_content_type
      get :show, params: { :id => id }
      response_json = JSON.parse(response.body)
      # compare @id and other annotation data
      new_resource_uri = response_json.delete('@id')
      expect(new_resource_uri).to eq(original_resource_uri)
      expect(response_json).to eq(data)
    end

  end

end
