package com.travelexpense.ui.auth

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.travelexpense.data.supabase.SupabaseClient
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

/**
 * 認証状態
 */
sealed class AuthState {
    object Loading : AuthState()
    object Authenticated : AuthState()
    object Unauthenticated : AuthState()
    data class Error(val message: String) : AuthState()
}

/**
 * 認証ViewModel
 */
class AuthViewModel : ViewModel() {
    private val _authState = MutableStateFlow<AuthState>(AuthState.Loading)
    val authState: StateFlow<AuthState> = _authState.asStateFlow()

    private val _email = MutableStateFlow("")
    val email: StateFlow<String> = _email.asStateFlow()

    private val _password = MutableStateFlow("")
    val password: StateFlow<String> = _password.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage.asStateFlow()

    init {
        checkAuthStatus()
    }

    // MARK: - Auth Status

    /**
     * 認証状態をチェック
     */
    fun checkAuthStatus() {
        viewModelScope.launch {
            val user = SupabaseClient.currentUser()
            _authState.value = if (user != null) {
                AuthState.Authenticated
            } else {
                AuthState.Unauthenticated
            }
        }
    }

    // MARK: - Actions

    /**
     * メールアドレス更新
     */
    fun onEmailChange(newEmail: String) {
        _email.value = newEmail
    }

    /**
     * パスワード更新
     */
    fun onPasswordChange(newPassword: String) {
        _password.value = newPassword
    }

    /**
     * ログイン
     */
    fun signIn() {
        if (_email.value.isEmpty() || _password.value.isEmpty()) {
            _errorMessage.value = "メールアドレスとパスワードを入力してください"
            return
        }

        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null

            try {
                SupabaseClient.signIn(_email.value, _password.value)
                _authState.value = AuthState.Authenticated
            } catch (e: Exception) {
                _errorMessage.value = "ログインに失敗しました: ${e.message}"
                _authState.value = AuthState.Error(e.message ?: "Unknown error")
            } finally {
                _isLoading.value = false
            }
        }
    }

    /**
     * サインアップ
     */
    fun signUp() {
        if (_email.value.isEmpty() || _password.value.isEmpty()) {
            _errorMessage.value = "メールアドレスとパスワードを入力してください"
            return
        }

        if (_password.value.length < 6) {
            _errorMessage.value = "パスワードは6文字以上で入力してください"
            return
        }

        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null

            try {
                SupabaseClient.signUp(_email.value, _password.value)
                _authState.value = AuthState.Authenticated
            } catch (e: Exception) {
                _errorMessage.value = "サインアップに失敗しました: ${e.message}"
                _authState.value = AuthState.Error(e.message ?: "Unknown error")
            } finally {
                _isLoading.value = false
            }
        }
    }

    /**
     * ログアウト
     */
    fun signOut() {
        viewModelScope.launch {
            _isLoading.value = true

            try {
                SupabaseClient.signOut()
                _authState.value = AuthState.Unauthenticated
            } catch (e: Exception) {
                _errorMessage.value = "ログアウトに失敗しました: ${e.message}"
            } finally {
                _isLoading.value = false
            }
        }
    }

    /**
     * フォームをクリア
     */
    fun clearForm() {
        _email.value = ""
        _password.value = ""
        _errorMessage.value = null
    }
}
