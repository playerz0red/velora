//
//  AuthView.swift
//  velora
//
//  Created by Ангелина Голубовская on 1.07.26.
//

import SwiftUI

struct AuthView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            background
            
            VStack(spacing: 18) {
                Spacer()
                    .frame(height: 20)
                
                logoBlock
                
                heartsBlock
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            authCard
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var background: some View {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.95, blue: 0.98),
                Color.white
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var logoBlock: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.pink, Color(red: 0.95, green: 0.68, blue: 0.85)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Velora")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.black, Color(red: 0.65, green: 0.18, blue: 0.55)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            Text("Начни свою историю ✦")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.pink)
        }
    }
    
    private var heartsBlock: some View {
        Image("heartImage", bundle: .module)
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 230)
            .shadow(color: .pink.opacity(0.25), radius: 18, x: 0, y: 10)
            .padding(.top, 5)
    }
    
    private var authCard: some View {
        VStack(spacing: 18) {
            VStack(spacing: 8) {
                Text("Добро пожаловать!")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.black)
                
                Text("Войдите, чтобы знакомиться с интересными людьми рядом с вами")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
            }
            
            VStack(spacing: 14) {
                AuthButton(
                    title: "Войти по email",
                    icon: "envelope",
                )
                
                AuthButton(
                    title: "Продолжить с Google",
                    icon: "globe.americas.fill",
                )
                
                AuthButton(
                    title: "Продолжить с Apple",
                    icon: "apple.logo",
                )
            }
            .padding(.top, 8)
            
            Rectangle()
                .fill(Color.gray.opacity(0.22))
                .frame(height: 1)
            
            HStack(spacing: 6) {
                Text("Нет аккаунта?")
                    .foregroundStyle(.secondary)
                
                Button {
                } label: {
                    Text("Зарегистрироваться")
                        .fontWeight(.semibold)
                        .foregroundStyle(.pink)
                }
            }
            .font(.system(size: 16))
            .padding(.top, 4)
        }
        .padding(.horizontal, 24)
        .padding(.top, 34)
        .padding(.bottom, 42)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 66, style: .continuous)
        )
        .shadow(color: .pink.opacity(0.14), radius: 28, x: 0, y: -8)
    }
}

struct AuthButton: View {
    let title: String
    var icon: String? = nil
    
    var body: some View {
        Button {
            
        } label: {
            HStack(spacing: 12) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.black)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                LinearGradient(
                    colors: [.clear, Color(red: 0.95, green: 0.09, blue: 0.5)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.black.opacity(0.48), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AuthView()
}
