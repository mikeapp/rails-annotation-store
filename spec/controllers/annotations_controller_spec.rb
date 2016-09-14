require 'rails_helper'

RSpec.describe AnnotationsController, type: :controller do

    it 'saves a Mirador annotation with SVG' do
      json = IO.read(Rails.root.join("spec", "json", "anno1.json"))
      request.env['CONTENT_TYPE'] = 'application/json'
      request.env['RAW_POST_DATA'] = json
      post :create
      data = JSON.parse(json)
      response_json = JSON.parse(response.body)
      expect(response_json['@id']).to be
      anno = Annotation.find_by(resource_id: response_json['@id'])
      expect(anno).to be
      expect(anno.data).to be
      expect(anno.targets.size).to eq 1
      expect(anno.targets.first.canvas).to eq data['on']['full']
      expect(anno.targets.first.manifest).to eq data['on']['within']['@id']
    end


end
