module ArtemisApi
  class Batch < ArtemisApi::Model
    json_type 'batches'
    related_to_one :zone
    related_to_one :seeding_unit
    related_to_one :harvest_unit

    def self.find(id:, client:, facility_id:, include: nil, force: false)
      client.find_one(self.json_type, id, facility_id: facility_id, include: include, force: force)
    end

    def self.find_all(client:, facility_id:, include: nil, filters: nil, page: nil)
      client.find_all(self.json_type, facility_id: facility_id, include: include, filters: filters, page: page)
    end

    def completions(include: nil, filters: {})
      ArtemisApi::Completion.find_all(facility_id: facility_id,
                                      client: client,
                                      include: include,
                                      filters: {crop_batch_ids: [id]}.with_indifferent_access.merge(filters))
    end

    def completion(completion_id, include: nil)
      ArtemisApi::Completion.find(id: completion_id,
                                  facility_id: facility_id,
                                  client: client,
                                  include: include)
    end

    def discards(include: nil)
      ArtemisApi::Discard.find_all(facility_id: facility_id,
                                   client: client,
                                   include: include,
                                   filters: {crop_batch_ids: [id]})
    end

    def discard(discard_id, include: nil)
      ArtemisApi::Discard.find(id: discard_id,
                               facility_id: facility_id,
                               client: client,
                               include: include)
    end

    def harvests(include: nil)
      ArtemisApi::Harvest.find_all(facility_id: facility_id,
                                   client: client,
                                   include: include,
                                   filters: {crop_batch_ids: [id]})
    end

    def harvest(harvest_id, include: nil)
      ArtemisApi::Harvest.find(id: harvest_id,
                               facility_id: facility_id,
                               client: client,
                               include: include)
    end

    def items(seeding_unit_id: nil, include: nil)
      ArtemisApi::Item.find_all(facility_id: facility_id,
                                batch_id: id,
                                client: client,
                                include: include,
                                filters: {seeding_unit_id: seeding_unit_id})
    end
  end
end
