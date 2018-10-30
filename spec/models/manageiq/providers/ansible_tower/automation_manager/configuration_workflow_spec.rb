describe ManageIQ::Providers::AnsibleTower::AutomationManager::ConfigurationWorkflow do
  let(:provider_with_authentication)         { FactoryBot.create(:provider_ansible_tower, :with_authentication) }
  let(:manager_with_authentication)          { provider_with_authentication.managers.first }
  let(:manager_with_configuration_workflows) { FactoryBot.create(:automation_manager_ansible_tower, :provider, :configuration_workflow) }
  subject { FactoryBot.create(:configuration_workflow, :manager => manager_with_configuration_workflows) }

  it_behaves_like 'ansible configuration_workflow'

  it 'designates orchestration stack type' do
    expect(described_class.stack_type).to eq('WorkflowJob')
  end

  describe '#run_with_miq_job' do
    it 'delegates request to template runner' do
      double_return = double(:signal => nil, :miq_task => double(:id => 'tid'))
      expect(ManageIQ::Providers::AnsibleTower::AutomationManager::TemplateRunner)
        .to receive(:create_job).with(hash_including(:ansible_template_id => subject.id, :userid => 'system')).and_return(double_return)
      expect(subject.run_with_miq_job({})).to eq('tid')
    end
  end
end
