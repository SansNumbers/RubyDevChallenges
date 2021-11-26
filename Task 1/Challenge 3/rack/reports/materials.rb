class MaterialsReport
  def wake
    @materials = Hash.new { |hash, key| hash[key] = [] }

    offices_name = CONN.exec("SELECT name, id FROM offices")

    @new_hash = {}
    result = {}

    offices_name.each do |data|
      result[data["name"]] = CONN.exec(
        "SELECT materials.type, materials.cost
             FROM (((( offices
             INNER JOIN zones ON offices.id = zones.office_id)
             INNER JOIN rooms ON zones.id = rooms.zone_id)
             INNER JOIN fixtures ON rooms.id = fixtures.room_id)
             INNER JOIN materials ON fixtures.id = materials.fixture_id)
             WHERE offices.id = #{data['id']};
             "
      )
      @new_hash[data["name"]] = {}
    end

    @cost = []

    result.each do |key, value|
      temp = 0
      value.each do |data|
        if @new_hash[key][data["type"]]
          @new_hash[key][data["type"]] += data["cost"].to_i
        else
          @new_hash[key][data["type"]] = data["cost"].to_i
        end
        temp += data["cost"].to_i
      end
      @cost << temp
    end

    @labels = Hash.new { |hash, key| hash[key] = [] }
    @data = Hash.new { |hash, key| hash[key] = [] }
    @new_hash.each do |key, value|
      value.each do |k, v|
        @labels[key] << k
        @data[key] << v
      end
    end
  end
end
