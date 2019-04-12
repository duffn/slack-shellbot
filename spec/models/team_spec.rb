require 'spec_helper'

describe Team do
  context '#purge!' do
    let!(:active_team) { Fabricate(:team) }
    let!(:inactive_team) { Fabricate(:team, active: false) }
    let!(:inactive_team_a_week_ago) { Fabricate(:team, updated_at: 1.week.ago, active: false) }
    let!(:inactive_team_two_weeks_ago) { Fabricate(:team, updated_at: 2.weeks.ago, active: false) }
    let!(:inactive_team_a_month_ago) { Fabricate(:team, updated_at: 1.month.ago, active: false) }
    it 'destroys teams inactive for two weeks' do
      expect do
        Team.purge!
      end.to change(Team, :count).by(-2)
      expect(Team.find(active_team.id)).to eq active_team
      expect(Team.find(inactive_team.id)).to eq inactive_team
      expect(Team.find(inactive_team_a_week_ago.id)).to eq inactive_team_a_week_ago
      expect(Team.find(inactive_team_two_weeks_ago.id)).to be nil
      expect(Team.find(inactive_team_a_month_ago.id)).to be nil
    end
  end
  context '#fs' do
    let!(:team) { Fabricate(:team) }
    it 'is a map' do
      expect(team.fs).to be_a FileSystemMap
    end
    it 'creates a file system for a channel' do
      expect do
        expect(team.fs['channel']).to be_a FileSystem
      end.to change(FileSystem, :count).by(1)
    end
    context 'filesystem' do
      let!(:fs) { team.fs['channel'] }
      it 'changes directory to root' do
        expect(fs.current_directory_entry).to be_a RootDirectoryEntry
      end
      it 'saves directory to root' do
        expect(fs.current_directory_entry).to eq fs.root_directory_entry
      end
    end
  end
end
