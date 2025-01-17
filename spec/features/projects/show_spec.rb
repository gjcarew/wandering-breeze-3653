require 'rails_helper'

RSpec.describe 'Project show page' do
  describe 'when I visit a project show page' do
    before :each do
      recycled_material_challenge = Challenge.create(theme: "Recycled Material", project_budget: 1000)
      furniture_challenge = Challenge.create(theme: "Apartment Furnishings", project_budget: 1000)

      news_chic = recycled_material_challenge.projects.create(name: "News Chic", material: "Newspaper")
      boardfit = recycled_material_challenge.projects.create(name: "Boardfit", material: "Cardboard Boxes")

      @upholstery_tux = furniture_challenge.projects.create(name: "Upholstery Tuxedo", material: "Couch")
      @lit_fit = furniture_challenge.projects.create(name: "Litfit", material: "Lamp")

      @jay = Contestant.create(name: "Jay McCarroll", age: 40, hometown: "LA", years_of_experience: 13)
      gretchen = Contestant.create(name: "Gretchen Jones", age: 36, hometown: "NYC", years_of_experience: 12)
      kentaro = Contestant.create(name: "Kentaro Kameyama", age: 30, hometown: "Boston", years_of_experience: 8)
      erin = Contestant.create(name: "Erin Robertson", age: 44, hometown: "Denver", years_of_experience: 15)

      ContestantProject.create(contestant_id: @jay.id, project_id: news_chic.id)
      ContestantProject.create(contestant_id: gretchen.id, project_id: news_chic.id)
      ContestantProject.create(contestant_id: gretchen.id, project_id: @upholstery_tux.id)
      ContestantProject.create(contestant_id: kentaro.id, project_id: @upholstery_tux.id)
      ContestantProject.create(contestant_id: kentaro.id, project_id: boardfit.id)
      ContestantProject.create(contestant_id: erin.id, project_id: boardfit.id)
    end

    it 'I see that projects name, material, and theme' do
      visit "/projects/#{@lit_fit.id}"
      expect(page).to have_content("Litfit")
      expect(page).to have_content("Material: Lamp")
      expect(page).to have_content("Challenge Theme: Apartment Furnishings")
    end

    it 'I see a count of contestants on this project' do
      visit "/projects/#{@upholstery_tux.id}"
      expect(page).to have_content('Number of Contestants: 2')
    end

    it 'I see average years of experience for contestants on the project' do
      visit "/projects/#{@upholstery_tux.id}"
      expect(page).to have_content("Average Contestant Experience: 10.0 years")
    end

    describe 'adding a contestant to a project' do
      it 'has a form to add a contestant to a project' do
        visit "/projects/#{@upholstery_tux.id}"
        expect(page).to have_field "Add contestant"
        expect(page).to have_button "Add Contestant to Project"
      end

      it 'When I fill out the form, it takes me to the project show page where the number of contestants has increased by 1' do
        visit "/projects/#{@upholstery_tux.id}"
        expect(page).to have_content('Number of Contestants: 2')
        fill_in 'Add contestant', with: "#{@jay.id}"
        click_button "Add Contestant to Project"
        expect(current_path).to eq("/projects/#{@upholstery_tux.id}")
        expect(page).to have_content('Number of Contestants: 3')
      end

      it 'the project is listed in the contestants index page' do
        visit "/projects/#{@upholstery_tux.id}"
        fill_in 'Add contestant', with: "#{@jay.id}"
        click_button "Add Contestant to Project"
        visit '/contestants'
        within "#contestant-#{@jay.id}" do
          expect(page).to have_content(@upholstery_tux.name)
        end
      end
    end
  end
end