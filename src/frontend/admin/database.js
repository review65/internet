import axios from 'axios';

export default {
  data() {
    return {
      equipments: []
    };
  },
  mounted() {
    this.fetchEquipments();
  },
  methods: {
    async fetchEquipments() {
      try {
        const response = await axios.get('http://localhost:3000/data/Equipments_list_brokened');
        this.equipments = response.data;
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    },
    formatDate(dateString) {
      const date = new Date(dateString);
      return date.toLocaleDateString('th-TH');
    },
    getStatusClass(status) {
      switch (status) {
        case 'รอซ่อม': return 'text-danger';
        case 'กำลังซ่อม': return 'text-warning';
        case 'ซ่อมสำเร็จ': return 'text-success';
        default: return '';
      }
    }
  }
};