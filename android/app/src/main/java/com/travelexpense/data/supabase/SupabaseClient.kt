package com.travelexpense.data.supabase

import io.github.jan.supabase.createSupabaseClient
import io.github.jan.supabase.gotrue.Auth
import io.github.jan.supabase.gotrue.auth
import io.github.jan.supabase.gotrue.providers.builtin.Email
import io.github.jan.supabase.postgrest.Postgrest
import io.github.jan.supabase.postgrest.from

/**
 * Supabaseクライアントのシングルトン
 */
object SupabaseClient {
    private const val SUPABASE_URL = "https://qooygcznuptnlzxjfemg.supabase.co"
    private const val SUPABASE_ANON_KEY = "YOUR_ANON_KEY_HERE" // TODO: BuildConfigから取得

    val client = createSupabaseClient(
        supabaseUrl = SUPABASE_URL,
        supabaseKey = SUPABASE_ANON_KEY
    ) {
        install(Auth)
        install(Postgrest)
    }

    // MARK: - Auth

    /**
     * ログイン
     */
    suspend fun signIn(email: String, password: String) {
        client.auth.signInWith(Email) {
            this.email = email
            this.password = password
        }
    }

    /**
     * サインアップ
     */
    suspend fun signUp(email: String, password: String) {
        client.auth.signUpWith(Email) {
            this.email = email
            this.password = password
        }
    }

    /**
     * ログアウト
     */
    suspend fun signOut() {
        client.auth.signOut()
    }

    /**
     * 現在のユーザー取得
     */
    fun currentUser() = client.auth.currentUserOrNull()

    /**
     * セッション取得
     */
    fun currentSession() = client.auth.currentSessionOrNull()
}
