module ArtemisApi
  class Batch < ArtemisApi::Model
    json_type 'batches'

    def self.find(id, facility_id, client, include: nil, force: false)
      client.find_one(self.json_type, id, facility_id: facility_id, include: include, force: force)
    end

    def self.find_all(facility_id, client, include: nil, filters: nil)
      client.find_all(self.json_type, facility_id: facility_id, include: include, filters: filters)
    end

    def actions
      ArtemisApi::Action.find_all(facility_id, client, filters: {crop_batch_ids: [id]})
    end
  end
end
