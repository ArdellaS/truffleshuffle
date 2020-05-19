import { Injectable } from '@angular/core';
import { User } from '../interfaces/user';
import { HttpClient } from '@angular/common/http';

@Injectable()
export class UserService {
  constructor(private http: HttpClient) { }

  getUserByID(id: number) {
    return this.http.get<User>(`/api/User/${id}`);
  }



}