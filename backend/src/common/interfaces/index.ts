export interface HeroById {
    id: number;
    user?: User;
}

export interface User {
    username: string;
    password: string;
}

export interface Hero {
    id: number;
    name: string;
}

export interface LoginRequest {
    username: string;
    password: string;
}

export interface AuthResponse {
    token: string;
}