class GenericItemUpdater
  def self.update(item)
    update_quality(item)
    update_sell_in(item)
  end
  def self.update_quality(item)
    if item.sell_in <= 0
      adjust(item, -2)
    else
      adjust(item, -1)
    end
  end

  def self.update_sell_in(item)
    item.sell_in -= 1
  end

  def self.adjust(item, amount)
    item.quality += amount
    item.quality = 50 if item.quality > 50
    item.quality = 0 if item.quality < 0
  end
end
class AgedBrieUpdater < GenericItemUpdater
  def self.name; "Aged Brie"; end
end
class SulfurasUpdater < GenericItemUpdater
  def self.name; "Sulfuras, Hand of Ragnaros"; end
end
class BackstagePassUpdater < GenericItemUpdater
  def self.name; "Backstage passes to a TAFKAL80ETC concert"; end
end

class ItemQualityUpdater
  UPDATERS = [
    AgedBrieUpdater,
    SulfurasUpdater,
    BackstagePassUpdater
  ]

  def self.updater_for_item(item)
    UPDATERS.detect{|klass| klass.name == item.name } || GenericItemUpdater
  end

  def self.update_quality(item)
    updater = updater_for_item(item)
    updater.update(item)
  end

end

def update_quality(items)
  items.each do |item|
    ItemQualityUpdater.update_quality(item)
  end
end

Item = Struct.new(:name, :sell_in, :quality)
