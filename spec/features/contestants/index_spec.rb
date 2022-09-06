require 'rails_helper'

RSpec.describe 'Contestants index' do
  describe 'when I visit the contestants index page' do
    before :each do
      recycled_material_challenge = Challenge.create(theme: "Recycled Material", project_budget: 1000)
      furniture_challenge = Challenge.create(theme: "Apartment Furnishings", project_budget: 1000)

      news_chic = recycled_material_challenge.projects.create(name: "News Chic", material: "Newspaper")
      boardfit = recycled_material_challenge.projects.create(name: "Boardfit", material: "Cardboard Boxes")

      upholstery_tux = furniture_challenge.projects.create(name: "Upholstery Tuxedo", material: "Couch")
      lit_fit = furniture_challenge.projects.create(name: "Litfit", material: "Lamp")

      @jay = Contestant.create(name: "Jay McCarroll", age: 40, hometown: "LA", years_of_experience: 13)
      @gretchen = Contestant.create(name: "Gretchen Jones", age: 36, hometown: "NYC", years_of_experience: 12)
      @kentaro = Contestant.create(name: "Kentaro Kameyama", age: 30, hometown: "Boston", years_of_experience: 8)
      @erin = Contestant.create(name: "Erin Robertson", age: 44, hometown: "Denver", years_of_experience: 15)


      ContestantProject.create(contestant_id: @jay.id, project_id: news_chic.id)
      ContestantProject.create(contestant_id: @gretchen.id, project_id: news_chic.id)
      ContestantProject.create(contestant_id: @gretchen.id, project_id: upholstery_tux.id)
      ContestantProject.create(contestant_id: @kentaro.id, project_id: upholstery_tux.id)
      ContestantProject.create(contestant_id: @kentaro.id, project_id: boardfit.id)
      ContestantProject.create(contestant_id: @erin.id, project_id: boardfit.id)
    end

    it 'I see a list of all contestants' do
      visit '/contestants'
      expect(page).to have_content(@jay.name)
      expect(page).to have_content(@gretchen.name)
      expect(page).to have_content(@kentaro.name)
      expect(page).to have_content(@erin.name)

    end

    it "Each contestant has a list of project names they've been on" do
      visit '/contestants'
      within "#contestant-#{@jay.id}" do
        expect(page).to have_content("News Chic")
      end

      within "#contestant-#{@gretchen.id}" do
        expect(page).to have_content("News Chic")
        expect(page).to have_content("Upholstery Tuxedo")
      end

      within "#contestant-#{@kentaro.id}" do
        expect(page).to have_content("Upholstery Tuxedo")
        expect(page).to have_content("Boardfit")
      end

      within "#contestant-#{@erin.id}" do
        expect(page).to have_content("Boardfit")
      end
    end
  end
end