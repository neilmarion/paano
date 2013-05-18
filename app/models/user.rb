class User < ActiveRecord::Base

  devise :database_authenticatable, :omniauthable,
         :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation,
          :first_name, :last_name, :provider, :uid

  validates_presence_of :provider
  validates_presence_of :uid

  has_many :evaluations, class_name: "RSEvaluation", as: :source
  has_many :questions
  has_many :answers
  has_many :comments
  has_many :posts

  has_reputation :karma,
    :source => [
      {:reputation => :questioning_skill},
      {:reputation => :answering_skill} ]

  has_reputation :answering_skill,
    :source => { :reputation => :answer_reputation, :of => :answers}

  has_reputation :questioning_skill,
    :source => { :reputation => :question_reputation, :of => :questions}

  scope :paginate, lambda { |page|
    page(page).per(PAGINATION['users_index']) }

  scope :join_rs_reputations,
    :joins => "LEFT JOIN rs_reputations ON users.id = rs_reputations.target_id AND rs_reputations.target_type = 'User'
        AND rs_reputations.reputation_name = 'karma' AND rs_reputations.active = 't'"

  scope :order_by_rep,
    order("COALESCE(rs_reputations.value, 0) DESC") 

  def self.from_omniauth(auth)
    
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.first_name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.username = auth["info"]["nickname"]
      user.email = auth["info"]["email"]
      user.password = Devise.friendly_token[0,20]
      if auth['extra']
        if auth['raw_info']
          if auth['education']
            auth['extra']['raw_info']['education'].each do |school|
              if school['type'] == 'College'
                user.concentration = school['concentration'][0]['name'] if school['concentration']
                user.college = school['school']['name'] if school['school']
                break
              end
            end
          end
        end
      end
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def karma
    reputation_for(:karma).to_i
  end

  def voted_up_for?(post)
    ReputationSystem::Evaluation.exists?(source_id: id, target_id: post.id, value: post.class.name == "Answer" ? SCORING['up'] : SCORING['question_up'])
  end

  def voted_down_for?(post)
    ReputationSystem::Evaluation.exists?(source_id: id, target_id: post.id, value: SCORING['down'])
  end

  def voted_for?(post)
    ReputationSystem::Evaluation.exists?(source_id: id, target_id: post.id)
  end

  def own_post?(post)
    case post.class.name
    when "Question"
      questions.exists? post
    when "Answer"
      answers.exists? post 
    when "Comment"
      comments.exists? post
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def self.search(query)
    User.where("first_name ILIKE ? OR last_name ILIKE ?", "%#{query}%", "%#{query}%")
  end

  def self.recent 
    order('created_at DESC')
  end

  def self.top
    join_rs_reputations.order_by_rep
  end
end
