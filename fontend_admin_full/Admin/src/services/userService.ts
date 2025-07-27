import axios from 'axios';
import API_BASE_URL from '../config';

export const getUsers = () => {
  return axios.get(`${API_BASE_URL}/users`);
};