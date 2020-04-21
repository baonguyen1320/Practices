class User < ApplicationRecord
  has_and_belongs_to_many :packages

  def total_fees
    subtotal = 0
    @user.packages.includes(:machines).each do |package|
      package.machines.each do |machine|
        subtotal += machine * price
      end
    end
    discount = package.discount
    return subtotal unless discount
    if discount.percent?
      amount_discount = subtotal * discount.amount * 0.01
      subtotal - amount_discount
    else 
      subtotal - discount.amount
  end

  # == Schema Information
  #
  # Table name: users
  #
  #  id                           :integer          not null, primary key
  #  name                         :string
  #  created_at                   :datetime         not null
  #  updated_at 
end

class Package < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :machines, through: :machine_packages
  belongs_to :discount


  # == Schema Information
  #
  # Table name: packages
  #
  #  id                           :integer          not null, primary key
  #  name                         :string
  #  discount_id                  :integer
  #  created_at                   :datetime         not null
  #  updated_at 
end

class Machine < ApplicationRecord
  has_many :packages, through: :machine_packages

  # == Schema Information
  #
  # Table name: machines
  #
  #  id                           :integer          not null, primary key
  #  name                         :string
  #  price                        :float
  #  created_at                   :datetime         not null
  #  updated_at                   :datetime         not null
end

class MachinePackage < ApplicationRecord
  belongs_to :machine
  belongs_to :package
  
  # == Schema Information
  #
  # Table name: machine_packages
  #
  #  id                           :integer          not null, primary key
  #  machine_id                   :integer
  #  package_id                   :integer
  #  quantity                     :integer
  #  created_at                   :datetime         not null
  #  updated_at                   :datetime         not null
end

class Discount < ApplicationRecord
  has_many :packages
  
  enum status: { percent: 0, amount: 1 }
  # == Schema Information
  #
  # Table name: machine_packages
  #
  #  id                           :integer          not null, primary key
  #  type                         :integer
  #  value                        :integer
  #  created_at                   :datetime         not null
  #  updated_at                   :datetime         not null
end
